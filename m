Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZKAWKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZKAWKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZKAWKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:10:23 -0500
Received: from tundra.namei.org ([65.99.196.166]:49216 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbZKAWKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:10:22 -0500
Date: Mon, 2 Nov 2009 09:09:54 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@parisplace.org>
cc: David Smith <david.daniel.smith@gmail.com>,
       tpmdd-devel@lists.sourceforge.net,
       Seiji Munetoh <seiji.munetoh@gmail.com>, akpm@linux-foundation.org,
       Daniel Walker <dwalker@fifo99.com>, Andy Isaacson <adi@hexapodia.org>,
       len.brown@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andy Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>
Subject: Re: [PATCH] tpm_tis: TPM_STS_DATA_EXPECT workaround
In-Reply-To: <7e0fb38c0910310724i6f440b3dmc2a16920d2ef4900@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0911020909420.9773@tundra.namei.org>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>  <1246455920.9140.28.camel@blackbox>  <20090720182732.GL6370@hexapodia.org>  <1252609714.4837.87.camel@blackbox>  <1252612471.4837.107.camel@blackbox>  <1252612709.30578.219.camel@desktop> 
 <1252613375.4837.121.camel@blackbox>  <f02dbbe70909111634q24df8746o8589394f7c30b28@mail.gmail.com>  <1253817781.8653.3.camel@dyn531367.br.ibm.com>  <b8394ab90910271945j10bd0aduda01cdc0610271f4@mail.gmail.com>
 <7e0fb38c0910310724i6f440b3dmc2a16920d2ef4900@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009, Eric Paris wrote:

> On Tue, Oct 27, 2009 at 10:45 PM, David Smith
> <david.daniel.smith@gmail.com> wrote:
> > Hi, can this be merged, please? Using the module parameter is not
> > optimal but it's better than the complete lack of support today.
> >
> > On Fri, Sep 25, 2009 at 3:43 AM, Rajiv Andrade
> > <srajiv@linux.vnet.ibm.com> wrote:
> >> This was already tested and, given no more comments on it, finally
> >> reviewed. Can it already be merged?
> 
> James can we get this merged?
> 
> Acked-by: Eric Paris <eparis@redhat.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
