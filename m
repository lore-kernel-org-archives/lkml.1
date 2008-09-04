Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYIDPv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYIDPv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYIDPvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:51:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43789 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYIDPvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:51:18 -0400
Message-ID: <48C003E7.4050704@kernel.org>
Date: Thu, 04 Sep 2008 08:51:03 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drop -funroll-loops for csum_partial_64.c
References: <20080904114611.GA18253@basil.nowhere.org>
In-Reply-To: <20080904114611.GA18253@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Drop -funroll-loops for csum_partial_64.c

Applied to tip:x86/core.  Thanks.

	-hpa
