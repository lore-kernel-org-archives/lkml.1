Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbXJ3Xyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbXJ3Xyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXJ3Xya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:54:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:46035 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbXJ3Xy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:54:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=bjdVHqrKJmqko8JTOrv7YZZ298j0iBonVtYjME57MXd4seJVk4BCgcG6Vkkkj6bzZ
	Zzkd0uWhs3wZ5UGlfQPag==
Date: Tue, 30 Oct 2007 16:54:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Adrian Bunk <bunk@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove __attribute_used__
In-Reply-To: <20071030235019.GS7227@stusta.de>
Message-ID: <alpine.DEB.0.9999.0710301654030.28111@chino.kir.corp.google.com>
References: <20071030235019.GS7227@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Adrian Bunk wrote:

> This patch removes the deprecated __attribute_used__.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
