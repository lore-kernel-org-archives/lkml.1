Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYAVUzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYAVUzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYAVUy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:54:58 -0500
Received: from mailout09.sul.t-online.de ([194.25.134.84]:53470 "EHLO
	mailout09.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299AbYAVUyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:54:55 -0500
Message-ID: <479657F3.2030901@t-online.de>
Date: Tue, 22 Jan 2008 21:54:11 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc8: iwl3945 gets stuck
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: bVxjpiZDghFbA6UkiRxhzHUfWaNEzrlczLm-v3xGrRg85gsoKd5LBanbIIAopv6QAe
X-TOI-MSGID: 8c468acc-978d-4193-aa2d-ddf5f9bf341c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

If I put some heavy load on the iwl3945, then the network connection
gets stuck after a some time. To fix it I have to reload the module.

AFAICS this problem was a topic on lkml almost 3 months ago. Any news
about this? I would be glad to help to track this down, but I have
no idea how to change the scaling algorithm to iwl-3945-rs .


Regards

Harri

