Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZBVLhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZBVLhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 06:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZBVLg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 06:36:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:46180 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbZBVLg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 06:36:56 -0500
MIME-Version: 1.0
In-Reply-To: <49A13765.5070902@s5r6.in-berlin.de>
References: <20090221194940.12602.54077.stgit@vmbox.hanneseder.net>
	 <49A13765.5070902@s5r6.in-berlin.de>
Date: Sun, 22 Feb 2009 12:36:53 +0100
Message-ID: <154e089b0902220336m2aeebc56p6f2af57118463352@mail.gmail.com>
Subject: Re: [PATCH] init/main.c: fix sparse warnings: context imbalance
From: Hannes Eder <hannes@hanneseder.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 12:30 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Hannes Eder wrote:
>> Impact: Attribute function 'init_post' with __releases(...).
>>
>> Fix this sparse warnings:
>
> It is not a fix, it's merely an annotation.

This patch 'better word for fix's a warning reported by sparse. What
better wording would you suggest?

Thanks, -Hannes
