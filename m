Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbZJDXOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbZJDXOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 19:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbZJDXON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 19:14:13 -0400
Received: from mout.perfora.net ([74.208.4.195]:53260 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583AbZJDXON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 19:14:13 -0400
MIME-Version: 1.0
From: vb@vsbe.com
Date: Sun, 4 Oct 2009 16:12:42 -0700
Message-ID: <f608b67d0910041612n64d377b8veab0e7433a979092@mail.gmail.com>
Subject: compiling certain files with extra compiler flags
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-Provags-ID: V01U2FsdGVkX18SzYyduJV9niquZsF4eqxcgkkrVP0Ro6N2+zt
 FYBQl/v1sTkmEl8/3wCkt2W7dLLQn1ILvOpA5SPY/2QZI5B34A
 KgIq0yZIr6j76iMBbxzBw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, what is the recommended way to compile certain kernel files with
certain extra flags? For instance, with '-g -O0' to be able to use the
debugger, or with -DDEBUG, etc.

TIA,
Vadim
