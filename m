Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZK3Vc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZK3Vc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZK3Vc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:32:26 -0500
Received: from 1wt.eu ([62.212.114.60]:52491 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZK3Vc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:32:26 -0500
Date: Mon, 30 Nov 2009 22:32:30 +0100
From: Willy Tarreau <w@1wt.eu>
To: ranjith kumar <ranjithproxy@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: source code of dynamic liner
Message-ID: <20091130213230.GA32739@1wt.eu>
References: <31cff80d0911301258j1a90e40bx8b9cd14740cc6d58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31cff80d0911301258j1a90e40bx8b9cd14740cc6d58@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 02:28:09AM +0530, ranjith kumar wrote:
> Hi,
> 
> Please tell me where can I find the 'source code of dynamic linker on
> linux for x86 processors'?

it's shipped with glibc (or any other dynamic C library).

Willy

