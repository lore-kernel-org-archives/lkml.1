Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZCRPCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZCRPCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZCRPCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:02:24 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56749 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbZCRPCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:02:23 -0400
Message-ID: <49C10CA8.3060801@s5r6.in-berlin.de>
Date: Wed, 18 Mar 2009 16:00:56 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: What's coming in the security subsystem
References: <alpine.LRH.2.00.0903181010030.6028@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0903181010030.6028@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
>       IMA: fix ima_delete_rules() definition

Since the term IMA and the implementation are new and specialist, the
meaning of this TLA is not widely known.  Hence it would be nice if you
prefixed IMA changes with "integrity: IMA:" like some of the other
pending IMA changes.

> Kentaro Takeda (8):
>       Add in_execve flag into task_struct.
>       Memory and pathname management functions.
>       Common functions for TOMOYO Linux.
>       File operation restriction part.
>       Domain transition handler.
>       LSM adapter functions.
>       Kconfig and Makefile
>       MAINTAINERS info

A "TOMOYO:" prefix would add a nice touch to these titles.
-- 
Stefan Richter
-=====-==--= --== =--=-
http://arcgraph.de/sr/
