Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbZIQDkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbZIQDkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759923AbZIQDkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:40:32 -0400
Received: from smtp-out-153.synserver.de ([212.40.180.153]:1030 "HELO
	smtp-out-153.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755039AbZIQDkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:40:32 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 5155
Date: Thu, 17 Sep 2009 05:40:33 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86-PAT tree merge causes keyboard problems
Message-ID: <20090917034033.GA1916@phenom2.trippelsdorf.de>
References: <20090915205259.GA1910@phenom2.trippelsdorf.de>
 <4AB018C0.30203@zytor.com>
 <20090916052657.GA1897@phenom2.trippelsdorf.de>
 <4AB07F39.4080205@zytor.com>
 <1253136483.4119.12.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253136483.4119.12.camel@sbs-t61.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 02:28:03PM -0700, Suresh Siddha wrote:
> On Tue, 2009-09-15 at 23:01 -0700, H. Peter Anvin wrote:
> > Okay, that explains the keyboard failure.  What you're really seeing is
> > a systemic failure of the X server.  Suresh thought it might be mapping
> > the frame buffer incorrectly.
> 
> Markus, Can you please check if the appended patch fixes the issue? It
> seems to fix the issue for me.

Yes, everything is fine again. Thanks Suresh.

-- 
Markus
