Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbYCYQa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbYCYQa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbYCYQ3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:29:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306AbYCYQ3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:29:51 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: [PATCH 0/2] get rid of mach_apic.h
Date: Tue, 25 Mar 2008 13:28:55 -0300
Message-Id: <1206462537-8427-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <20080325150630.GA13828@elte.hu>
References: <20080325150630.GA13828@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yeah, the last patch sent was totally brown paper bag. I sent a previous
version from the wrong machine, sorry.

ingo, the new testing also unveiled a new catch, so I'm resending _both_ patches.
please ignore both of them from the last run, and apply these instead


