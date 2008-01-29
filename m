Return-Path: <linux-kernel-owner+w=401wt.eu-S933652AbYA2TOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbYA2TOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYA2TOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:14:12 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43993 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbYA2TOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:14:10 -0500
Subject: Re: [PATCH -mm] kprobes: kretprobe user entry-handler (updated)
From: Jim Keniston <jkenisto@us.ibm.com>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ananth@in.ibm.com
In-Reply-To: <479B7A78.5090604@gmail.com>
References: <479B7A78.5090604@gmail.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 11:08:57 -0800
Message-Id: <1201633738.4786.1.camel@dyn9047018096.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-01-26 at 23:52 +0530, Abhishek Sagar wrote:
> This is a repost of a patch which was reviewed earlier at:
> http://lkml.org/lkml/2007/11/13/58 (thanks to Jim Keniston and Srinivasa for their review comments). This provides support to add an optional user defined callback to be run at function entry of a kretprobe'd function. It also modifies the kprobe smoke tests to include an entry-handler during the kretprobe sanity test.
> 
> Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
> ---

Acked-by: Jim Keniston <jkenisto@us.ibm.com>
Tested (again) on i386.

