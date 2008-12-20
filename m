Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbYLTNgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYLTNgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 08:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYLTNga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 08:36:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:8244 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYLTNg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 08:36:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Q2sNonO618uWphBkZ5FHE9KYfxy9WsRgeNZo5A6kNDaf+Imenx7djO1P8YJQq/irG5
         dtvx80N3AOJsDhGoaXka7UHbDrtItKlNK9+u7t5A5tJkmct/t2bZMYXmUR/Aem2RNJEo
         dbC5TTjsc3D54Q22s1UlkAPYhTtGnyBHN7X5Q=
Message-ID: <494CF4A6.6050200@gmail.com>
Date: Sat, 20 Dec 2008 18:35:34 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.1.17) Gecko/20081109 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Nick Warne <nick@ukfsn.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] New x86_64 boot logo
References: <20081220105658.35ebd2bc@sauron.linicks.net>
In-Reply-To: <20081220105658.35ebd2bc@sauron.linicks.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Warne wrote:
> Hi all,
> 
> I have been running a full true 64 bit system now for a few months
> (Slamd64), and this made me think...
> 
> Introduce a new fb boot logo to reflect running a x86_64 kernel/system.
> 
> Preview: http://www.nick.ukfsn.org/stuff/logo_linux64_clut224.ppm

IMHO, this looks ugly. In this new logo, there are three spatially 
separated places with fine detail (the eyes of the penguin and the paws 
with the number), as opposed to the old logo that had fine detail only 
in one of these places.

-- 
Alexander E. Patrakov
