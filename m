Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYHHOa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYHHOa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 10:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYHHOas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 10:30:48 -0400
Received: from khc.piap.pl ([195.187.100.11]:46054 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbYHHOar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 10:30:47 -0400
To: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: including .c files ?
References: <ac9c93b10808080425p321fac13y72a5b2b4e67ee6a9@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 08 Aug 2008 16:30:45 +0200
In-Reply-To: <ac9c93b10808080425p321fac13y72a5b2b4e67ee6a9@mail.gmail.com> (Frans Meulenbroeks's message of "Fri\, 8 Aug 2008 13\:25\:36 +0200")
Message-ID: <m3abfnk296.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Frans Meulenbroeks" <fransmeulenbroeks@gmail.com> writes:

> Generally I would expect that if the .c file contains some standalone
> functionality then it should probably be a .c file on its own with a
> well defined interface.

Doesn't work when you need conditional compilation.
-- 
Krzysztof Halasa
