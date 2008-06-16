Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbYFPSHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbYFPSHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbYFPSHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:07:45 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35738 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbYFPSHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:07:44 -0400
Subject: Re: kvm causing memory corruption?  now 2.6.26-rc4
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
In-Reply-To: <48512028.3070104@qumranet.com>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
	 <1206551794.7883.7.camel@nimitz.home.sr71.net>
	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>
	 <1206629709.7883.30.camel@nimitz.home.sr71.net>
	 <47EBB63E.2060306@qumranet.com>
	 <1212445810.8211.9.camel@nimitz.home.sr71.net>
	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>
	 <48512028.3070104@qumranet.com>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 11:07:39 -0700
Message-Id: <1213639659.29994.17.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 16:10 +0300, Avi Kivity wrote:
> Stumped.  Please post .config, will try to reproduce.

http://sr71.net/~dave/linux/config-2.6.26-rc6

-- Dave

