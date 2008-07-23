Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYGWH5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYGWH5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYGWH50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:57:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:65147 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYGWH5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:57:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NBevbzwQL9nbFwkv8eNMvw3MkQpo1TfxcSjXPCMzhjkmvfRhNoEFz3c1AKv65/SGfE
         DoGKbl2qpZed6Db+9OG2oTqQoBq9IofoPMorGfCYEW8pThZSn7+B3t/rEIWNqzRUuB4L
         ezRRQEd8Pccow3C8YvFmHqriJB+5OW/cejjFs=
Message-ID: <d4b984a30807230057t319eca71g32262305bdb07582@mail.gmail.com>
Date: Wed, 23 Jul 2008 09:57:24 +0200
From: "Alessandro Guido" <ag@alessandroguido.name>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [BUG] kernel BUG at net/core/dev.c:1328!
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20080722.155611.176476925.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d4b984a30807210914nd4d0db5yb7b93ca5143ff0d5@mail.gmail.com>
	 <20080721.092027.14394005.davem@davemloft.net>
	 <d4b984a30807220254t1aaf6ac4q874329966511b0c5@mail.gmail.com>
	 <20080722.155611.176476925.davem@davemloft.net>
X-Google-Sender-Auth: e14599cf96f73cc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing the latest Linus' git which includes your patch
(2.6.26-06077-gc010b2f) and the problem is fixed.

Thank you!
