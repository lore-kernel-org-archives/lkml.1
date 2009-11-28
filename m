Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZK1IRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZK1IRp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 03:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZK1IRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 03:17:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:40390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbZK1IRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 03:17:44 -0500
Message-ID: <4B10DC30.5050900@kernel.org>
Date: Sat, 28 Nov 2009 00:15:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 0/9] pci: update pci bridge resource to get more big range
 for devices under it - v13
References: <4ADEB601.8020200@kernel.org>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B10D286.4020607@kerne!
 l.org>
In-Reply-To: <4B10D286.4020607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji, Jesse:

or you can check it from

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git for-pci

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-2.6-yinghai.git;a=shortlog;h=refs/heads/for-pci

Thanks

Yinghai
