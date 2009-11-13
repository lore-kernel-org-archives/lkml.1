Return-Path: <linux-kernel-owner+w=401wt.eu-S932278AbZKMWlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbZKMWlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbZKMWlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:41:46 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45486 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbZKMWlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:41:46 -0500
Date: Fri, 13 Nov 2009 22:41:46 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 2/3] vc: Add support for hiding the cursor when
	creating VTs
Message-ID: <20091113224146.GA7756@srcf.ucam.org>
References: <1258142222-16092-1-git-send-email-mjg@redhat.com> <1258142222-16092-2-git-send-email-mjg@redhat.com> <4AFDDFF3.2070601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFDDFF3.2070601@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 02:38:43PM -0800, H. Peter Anvin wrote:
> On 11/13/2009 11:57 AM, Matthew Garrett wrote:
> >  
> >  static int con_open(struct tty_struct *, struct file *);
> >  static void vc_init(struct vc_data *vc, unsigned int rows,
> > -		    unsigned int cols, int do_clear);
> > +		    unsigned int cols, int do_clear)
> 
> Uhm... this doesn't compile.

Yes, I managed to send the wrong version. You should have the correct 
one already.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
