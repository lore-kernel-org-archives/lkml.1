Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbYBYXBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbYBYXBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761987AbYBYXAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:00:51 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:65238 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761925AbYBYXAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:00:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tjpefWBJnP178PSMK1z5EBpTueVncMo3vfw0/4WoN8MNUNfWG8F01GF3VEub/2IjRDsLCBE0lJOPvWR854+wGnT+0j1wedmaaEOBeKjhUXd9oe7eGcFVBfIlqLEblUzaca3U2yhPvMaq0SOAm2MGMO94y1ZeTt8Ytth8oVCFQSY=
Message-ID: <7c86c4470802251500mafec0dl535591971258de69@mail.gmail.com>
Date: Tue, 26 Feb 2008 00:00:46 +0100
From: "stephane eranian" <eranian@googlemail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: 2.6.24 new perfmon kernel code base + libpfm + pfmon finally available!
Cc: linux-kernel@vger.kernel.org, ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <84144f020802251113m2cede5bbx9044ec1fc6d11f0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470802250900g1eea7a26m1900c4d8ed621dfd@mail.gmail.com>
	 <84144f020802251113m2cede5bbx9044ec1fc6d11f0c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka,

On Mon, Feb 25, 2008 at 8:13 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Stephane,
>
>
>  On Mon, Feb 25, 2008 at 7:00 PM, stephane eranian
>  <eranian@googlemail.com> wrote:
>  >  I have finally released the perfmon2 kernel patch for kernel v2.6.24. It
>  >  took longer than expected to due my job change and several technical issues
>  >  related to perfmon kernel bugs.
>
>  [snip]
>
>
>  >  As usual all files and more detailed change logs can be downloaded
>  >  from our website at:
>  >
>  >        http://perfmon.sourceforge.net
>
>  Why not post the patches on LKML for review?
>
I have done that in the past. I will do this again. But if you look at
the patch as it is released, you will
see that it is very large. Not that easy to split for LKML review.
With now with GIT that may be easier.
I intend to start posting small bits and pieces from now on.
