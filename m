Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbZDQE5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbZDQE5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 00:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758455AbZDQE5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 00:57:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:29304 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419AbZDQE5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 00:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <74602b0d6e166c6a657f3d9b7f6c3890b0783326.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
	 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
	 <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
	 <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
	 <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu>
	 <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu>
	 <f87119e246276eb41047985c97b74a5b79adc259.1239874968.git.monstr@monstr.eu>
	 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
	 <a3f7086da43a5d4f994344a07a75568f679095d6.1239874968.git.monstr@monstr.eu>
	 <74602b0d6e166c6a657f3d9b7f6c3890b0783326.1239874968.git.monstr@monstr.eu>
Date: Fri, 17 Apr 2009 14:57:20 +1000
Message-ID: <1d3f23370904162157k1b29ac5bu44226b371b8cb289@mail.gmail.com>
Subject: Re: [microblaze-uclinux] [PATCH 09/11] microblaze: Move start_thread 
	to process.c
From: John Williams <john.williams@petalogix.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 7:56 PM,  <monstr@monstr.eu> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
> This change is due to upcomming MMU merge
>
> Signed-off-by: Michal Simek <monstr@monstr.eu>

ACK
