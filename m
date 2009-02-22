Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZBVLbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZBVLbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 06:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbZBVLa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 06:30:59 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33311 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZBVLa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 06:30:58 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A13765.5070902@s5r6.in-berlin.de>
Date: Sun, 22 Feb 2009 12:30:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: Ingo Molnar <mingo@elte.hu>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init/main.c: fix sparse warnings: context imbalance
References: <20090221194940.12602.54077.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221194940.12602.54077.stgit@vmbox.hanneseder.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> Impact: Attribute function 'init_post' with __releases(...).
> 
> Fix this sparse warnings:

It is not a fix, it's merely an annotation.
-- 
Stefan Richter
-=====-==--= --=- =-==-
http://arcgraph.de/sr/
