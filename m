Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYLCQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYLCQdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYLCQdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:33:16 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:42345 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbYLCQdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:33:15 -0500
Message-ID: <4936B4C7.909@s5r6.in-berlin.de>
Date: Wed, 03 Dec 2008 17:33:11 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: LINUX NEWBIE <lnxnewbie@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Add new capture device driver in Linux
References: <55fdf7050812021644o3bffc326n1eedfb699c2a141c@mail.gmail.com>
In-Reply-To: <55fdf7050812021644o3bffc326n1eedfb699c2a141c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LINUX NEWBIE wrote:
>      How do I add a new capture device driver similar to cx23885?

Specific documentation and developer contacts:
    http://www.linuxtv.org/

General advice:
    linux/Documentation/SubmittingDrivers ("Resources" section)
furthermore
    linux/Documentation/HOWTO
    linux/Documentation/development-process/
    linux/MAINTAINERS
and when you are ready to submit the driver
    linux/Documentation/SubmittingPatches
    linux/Documentation/SubmitChecklist
-- 
Stefan Richter
-=====-==--- ==-- ---==
http://arcgraph.de/sr/
