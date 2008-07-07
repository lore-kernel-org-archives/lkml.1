Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYGGWoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYGGWoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYGGWoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:44:01 -0400
Received: from vena.lwn.net ([206.168.112.25]:58575 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbYGGWoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:44:00 -0400
Date: Mon, 7 Jul 2008 16:43:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andres Salomon <dilinger@queued.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Cortland Setlow <csetlow@tower-research.com>,
       video4linux-list@redhat.com,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] ov7670: clean up ov7670_read semantics
Message-ID: <20080707164358.6ffc07bf@bike.lwn.net>
In-Reply-To: <20080707014126.0809a5bd@fred>
References: <20080707014126.0809a5bd@fred>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Mauro]

On Mon, 7 Jul 2008 01:41:26 +0000
Andres Salomon <dilinger@queued.net> wrote:

> This makes ov7670_read return <0 in the case of an error, and 0 upon
> success. 

The change seems fine to me.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
