Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYAIEZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYAIEZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYAIEZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:25:44 -0500
Received: from namei.org ([69.55.235.186]:41738 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752213AbYAIEZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:25:44 -0500
Date: Wed, 9 Jan 2008 15:25:31 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Kentaro Takeda <takedakn@nttdata.co.jp>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #6 retry 08/21] Utility functions and policy manipulation
 interface.
In-Reply-To: <20080109005421.598247963@nttdata.co.jp>
Message-ID: <Xine.LNX.4.64.0801091524500.13216@us.intercode.com.au>
References: <20080109005320.323184643@nttdata.co.jp> <20080109005421.598247963@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008, Kentaro Takeda wrote:

> Common functions for TOMOYO Linux.
> 
> TOMOYO Linux uses /sys/kernel/security/tomoyo interface for configuration.

Why aren't you using securityfs for this?  (It was designed for LSMs).


- James
-- 
James Morris
<jmorris@namei.org>
