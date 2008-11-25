Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYKYBJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYKYBJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYKYBJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 20:09:07 -0500
Received: from tundra.namei.org ([65.99.196.166]:48969 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbYKYBJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 20:09:06 -0500
Date: Tue, 25 Nov 2008 12:08:51 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Hannes Eder <hannes@hanneseder.net>
cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] CRED: fix sparse warnings
In-Reply-To: <154e089b0811241314t3291ea30w6268bb5b2b5c7c53@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0811251208100.18891@tundra.namei.org>
References: <154e089b0811241314t3291ea30w6268bb5b2b5c7c53@mail.gmail.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008, Hannes Eder wrote:

> Impact: fix sparse warnings
> 
> Fix the following sparse warnings:
> 
>   security/security.c:228:2: warning: returning void-valued expression
>   security/security.c:233:2: warning: returning void-valued expression
>   security/security.c:616:2: warning: returning void-valued expression
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
