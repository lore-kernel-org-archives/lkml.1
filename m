Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYHDDhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYHDDhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 23:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYHDDhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 23:37:03 -0400
Received: from ozlabs.org ([203.10.76.45]:51761 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbYHDDhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 23:37:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] stop_machine: remove unused variable
Date: Mon, 4 Aug 2008 13:36:35 +1000
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <489123E6.5070606@cn.fujitsu.com>
In-Reply-To: <489123E6.5070606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808041336.35642.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008 12:31:02 Li Zefan wrote:
>  static int stop_cpu(struct stop_machine_data *smdata)
>  {
>  	enum stopmachine_state curstate = STOPMACHINE_NONE;
> -	int uninitialized_var(ret);
>

Thanks, applied!

Rusty.
