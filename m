Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbYE0QNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbYE0QNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759075AbYE0QNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:13:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:51804 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292AbYE0QNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:13:10 -0400
Message-ID: <f362c47d0805270913g78541fb7q594c17b22c3de4d9@mail.gmail.com>
Date: Tue, 27 May 2008 17:13:09 +0100
From: "Tom Doherty" <tomd@singlesecond.com>
To: linux-kernel@vger.kernel.org
Subject: TCP tuning
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello
could someone please clarify whether setting net.ipv4.tcp_{r,w}mem sysctl
is sufficient on a 2.6.9 kernel? TCP tuning guides I've seen give
conflicting advice
on whether to use net.ipv4.tcp_mem also.
Any clarification would be appreciated.
Thanks a lot
Tom
