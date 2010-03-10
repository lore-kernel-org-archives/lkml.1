Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0CJJbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:31:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62502 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0CJJbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:31:07 -0500
Message-ID: <4B976713.6020901@cn.fujitsu.com>
Date: Wed, 10 Mar 2010 17:32:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [kernel group] daily report 10/03/10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- investigate the abnormality of 'sysbench mutex' (Xiao)

- kvm: learning basic principle (Lai)

- we've sent the test program to Steven in private mail, and he has managed
  to trigger kernel warning and segfaults. (Li)

- sent a mail to FJ to explain the value of trace-cmd/kernelshark. (Li)
