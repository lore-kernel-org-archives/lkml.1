Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZIITRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZIITRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 15:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZIITRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 15:17:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbZIITRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 15:17:38 -0400
Date: Wed, 9 Sep 2009 15:16:37 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Paul Sheer <paulsheer@gmail.com>
Cc: linux-kernel@vger.kernel.org, roque@di.fc.ul.pt
Subject: Re: TCP kernel tables overflowing after sustained 1000 new
 connections  per second
Message-ID: <20090909151637.6e5fb595@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <c67e3dc60909091146j4aeaf422v4e0543eff87c7f9a@mail.gmail.com>
References: <c67e3dc60909091146j4aeaf422v4e0543eff87c7f9a@mail.gmail.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009 20:46:07 +0200
Paul Sheer <paulsheer@gmail.com> wrote:

> I am developing a high-performance application, and testing against Apache.
> It makes 1000 new connections to Apache per second.
> 
> After 16 seconds the test grinds to a halt. A Linux kernel problem. There are
> several hurdles to overcome when trying to sustain such through-put. Some
> are configuration issues, others I believe are real problems with the kernel
> internals. I'll discuss these all below.
> 

You should send this to netdev@vger.kernel.org .
