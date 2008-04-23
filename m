Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbYDWLql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbYDWLql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYDWLqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:46:30 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:44305
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751604AbYDWLq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:46:29 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 0/2] sched fixes for suboptimal balancing
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Date: Wed, 23 Apr 2008 07:13:24 -0400
Message-ID: <20080423111313.4981.37345.stgit@novell1.haskins.net>
In-Reply-To: <480DDC48.BA47.005A.0@novell.com>
References: <480DDC48.BA47.005A.0@novell.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are my proposed fixes for the issue Dmitry has highlighted in:

http://lkml.org/lkml/2008/4/22/296

This is an RFC, and it applies to sched-devel.

Regards,
-Greg
