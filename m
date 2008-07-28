Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbYG1SN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbYG1SN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYG1SNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:13:17 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2688 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYG1SNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:13:16 -0400
Subject: Re: [patch 01/15] kmsg: Kernel message catalog macros.
From: Joe Perches <joe@perches.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Michael Holzheu <holzheu@de.ibm.com>
In-Reply-To: <20080728175511.023246676@de.ibm.com>
References: <20080728175355.734299984@de.ibm.com>
	 <20080728175511.023246676@de.ibm.com>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 11:12:04 -0700
Message-Id: <1217268724.9355.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.3mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 19:53 +0200, Martin Schwidefsky wrote:
> The kmsg component name is defined per source file with the KMSG_COMPONENT
> macro.

Why not use KBUILD_MODNAME?

