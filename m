Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYCYRfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYCYRfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbYCYRfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:35:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:54690 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbYCYRfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:35:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=N2D6aMOt7huCQ4S6ve4BvGCC+/D0flMDfqQJbeoJcMOm+oV2yd0QkSs3uzKMwjD3sx5ctZ+EIhf92ZBM3ebTA+ET8w0nI2UNRn7elwC5F7WLK5BvMYJt150wOCVqw+wBXJm5I/ApeZsthUQDpISMTGSMfxOf9ZgNq+JQwF9pqg8=
Date: Tue, 25 Mar 2008 20:34:28 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86 - relocate_kernel cleanup
Message-ID: <20080325173428.GA9237@cvg>
References: <20080322210005.117475478@gmail.com> <47E576B9.6090205@zytor.com> <47E577B9.1010403@zytor.com> <20080323111017.GA7612@cvg> <20080325155657.GD27174@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325155657.GD27174@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Mar 25, 2008 at 04:57:00PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > You know, Peter, I'm a bit scared that these flags are in number of 
| > files and could break others queued patches...
| 
| as long as your work against x86.git/latest you shouldnt be worried 
| about any clashes.
| 
| 	Ingo
| 
oh, thanks Ingo, I continue workin on this realm ;)

		- Cyrill -
