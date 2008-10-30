Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYJ3GEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYJ3GEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 02:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYJ3GEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 02:04:14 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:58172 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYJ3GEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 02:04:13 -0400
X-Greylist: delayed 2196 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 02:04:12 EDT
Message-ID: <490945C0.5070209@nttdata.co.jp>
Date: Thu, 30 Oct 2008 14:27:28 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Kentaro Takeda <takedakn@nttdata.co.jp>, sds@tycho.nsa.gov,
       jmorris@namei.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [TOMOYO #11 (linux-next) 00/11] TOMOYO Linux
References: <20081020073423.024299308@nttdata.co.jp> <490524DA.1020705@nttdata.co.jp> <20081029191855.GA23612@us.ibm.com>
In-Reply-To: <20081029191855.GA23612@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2008 05:27:32.0964 (UTC) FILETIME=[35B55240:01C93A50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2008 4:18 AM, Serge E. Hallyn wrote:
> The users' list seems quite sparse, though.  Who exactly does use this,
> and why?  (I don't mean that to sound adversarial, but while I think I
> know how it differs from selinux, I'm not clear on when or why its
> differences would be advantageous.)
> 
> -serge

I assume you saw the English version of users' list which was
created very recently. At the moment, most of the TOMOYO Linux
project users are Japanese as it is not merged *yet*. ;-)

Well, I think I need to prove the existence of users.
Page views total since 2005-11-11: 1,272,647
Downloads total since 2005-11-11: 28,501
Please visit the following url to find number of users are increasing.
http://sourceforge.jp/project/stats/index.php?report=months&group_id=1973&language_id=1

The following wiki page is designed to be an entry for newcomers.
http://elinux.org/TomoyoLinux (7,499 page views)

The following page has been maintained by non-Japanese users.
http://cblfs.cross-lfs.org/index.php/TOMOYO (3,252 page views)

Mandriva 2008.1 and 2009.0 have TOMOYO Linux enabled kernels.
http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/mandriva2008.1/
http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/mandriva2009.0/

Turbolinux 11 Server and Turbolinux Client 2008, too.
http://tomoyo.sourceforge.jp/ja/1.5.x/1st-step/tl11s/
http://tomoyo.sourceforge.jp/ja/1.6.x/1st-step/tc2008/

We have been providing Ubuntu based LiveCD and CentOS based LiveCD.
(= Ubuntu/CentOS LiveCD + TOMOYO Kernel and utilities)
http://tomoyo.sourceforge.jp/wiki-e/?TomoyoLive

Reference documentations and web pages are provided in
English and Japanese.
http://tomoyo.sourceforge.jp/index.html.en

We have open forums and have had feedbacks from non-Japanese
people.
http://sourceforge.jp/forum/forum.php?forum_id=11352&language_id=1

Some Japanese security related NGO server has been protected by
TOMOYO Linux. (not play machine)
http://www.jnsa.org/result/2007/tech/secos/secureos.pdf
(sorry, there's no English version)

So, I think it's safe to say TOMOYO Linux is a *real* project and
there are users. :-)

Best regards,
Toshiharu Harada
haradats@nttdata.co.jp

