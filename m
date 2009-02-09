Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbZBIOoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbZBIOoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZBIOoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:44:03 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33793 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZBIOoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:44:01 -0500
Subject: Re: [RFC PATCH 0/2] splice patches for ftrace
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <cover.1234159200.git.eduard.munteanu@linux360.ro>
References: <cover.1234159200.git.eduard.munteanu@linux360.ro>
Date: Mon, 09 Feb 2009 16:43:58 +0200
Message-Id: <1234190638.25364.28.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 08:15 +0200, Eduard - Gabriel Munteanu wrote:
> This implements splice support so we can use it in kmemtrace-user. Please
> check it out and tell me what you think.

I am not a splice or ftrace expert but modulo the comments from Ingo:

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

