Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZDQEzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZDQEzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 00:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbZDQEzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 00:55:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:27235 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbZDQEzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 00:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
	 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
	 <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
	 <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
	 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
	 <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu>
	 <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu>
Date: Fri, 17 Apr 2009 14:55:23 +1000
Message-ID: <1d3f23370904162155r78bd14eai85edd822bcbaf11e@mail.gmail.com>
Subject: Re: [microblaze-uclinux] [PATCH 06/11] microblaze: Remove sparse 
	error in traps.c
From: John Williams <john.williams@petalogix.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 7:56 PM,  <monstr@monstr.eu> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
> CHECK   arch/microblaze/kernel/traps.c
> arch/microblaze/kernel/traps.c:37:47: warning: Using plain integer as NULL pointer
> CC      arch/microblaze/kernel/traps.o
>
> Signed-off-by: Michal Simek <monstr@monstr.eu>

ACK
