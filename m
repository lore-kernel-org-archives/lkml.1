Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZBZQc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZBZQc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbZBZQcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:32:17 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33016 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbZBZQcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:32:16 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 26 Feb 2009 08:32:10 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Tony Battersby <tonyb@cybernetics.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] [-mm] epoll: use real type instead of void *
In-Reply-To: <49A42E62.3090003@cybernetics.com>
Message-ID: <alpine.DEB.2.00.0902260831520.31638@alien.or.mcafeemobile.com>
References: <49A42E62.3090003@cybernetics.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Tony Battersby wrote:

> eventpoll.c uses void * in one place for no obvious reason; change
> it to use the real type instead.

Acked-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


