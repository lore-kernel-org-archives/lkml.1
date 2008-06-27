Return-Path: <linux-kernel-owner+w=401wt.eu-S1763941AbYF0VBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763941AbYF0VBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbYF0VBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:01:08 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59543 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193AbYF0VBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:01:07 -0400
Date: Fri, 27 Jun 2008 23:01:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Userspace tools for BSD process accounting (v3)
Message-ID: <20080627210152.GA29245@uranus.ravnborg.org>
References: <e2e108260806180134u43413ef5ke226745a8a911e7b@mail.gmail.com> <200806181139.06612.caglar@pardus.org.tr> <200806181145.14265.caglar@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806181145.14265.caglar@pardus.org.tr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 11:45:13AM +0300, S.Çağlar Onur wrote:
> Hi;
> 
> 18 Haz 2008 Çar tarihinde, S.Çağlar Onur şunları yazmıştı: 
> > 18 Haz 2008 Çar tarihinde, Bart Van Assche şunları yazmıştı: 
> > > The file init/Kconfig in the kernel source tree refers to the URL
> > > http://www.physik3.uni-rostock.de/tim/kernel/utils/acct/ as the
> > > download location for userspace tools for processing the v3 BSD
> > > process accounting file format. This URL is no longer valid
> > > unfortunately. Anyone any idea where these tools can be downloaded ?
> > 
> > http://savannah.gnu.org/projects/acct/
> 
> Following patch corrects URL of "The GNU Accounting Utilities" in init/Kconfig.
> 
> Noticed by: Bart Van Assche" <bart.vanassche@gmail.com>
> 
> Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
> 
>  init/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 6199d11..10077ce 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -171,7 +171,7 @@ config BSD_PROCESS_ACCT_V3
>  	  process and it's parent. Note that this file format is incompatible
>  	  with previous v0/v1/v2 file formats, so you will need updated tools
>  	  for processing it. A preliminary version of these tools is available
> -	  at <http://www.physik3.uni-rostock.de/tim/kernel/utils/acct/>.
> +	  at <http://www.gnu.org/software/acct/>.
>  
>  config TASKSTATS
>  	bool "Export task/process statistics through netlink (EXPERIMENTAL)"

Applied

	Sam
