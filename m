Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805Ab0AYOu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab0AYOu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974Ab0AYOu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:50:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41423 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0AYOu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:50:28 -0500
Subject: Re: [PATCH 12/12] Revert "perf record: Intercept all events"
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <a6b9f31a1001250647k7273ab80j771d673595d3ad80@mail.gmail.com>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1264167553-6510-13-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100125022351.GD24418@ghostprotocols.net>
	 <a6b9f31a1001250647k7273ab80j771d673595d3ad80@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 15:50:13 +0100
Message-ID: <1264431013.4283.1912.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 23:47 +0900, Hitoshi Mitake wrote:
> 
> What does "DSO" mean? Sorry, I'm not good at English...

Dynamic Shared Object, basically dynamic executables and .so files.

