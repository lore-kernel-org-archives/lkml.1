Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZKIRIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZKIRIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbZKIRIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:08:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:47318 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbZKIRIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=fgGoTdHl6gM9ELQsFg/FUbkmrgnGQVq41sOPwRqw/wSvHpYuEat7BIFoLiM+esVLxm
         cPbJSya84bYUIBk3KHZYdg+W3SOqHcEoDulD0F1JB7zS2x2mUKS73bBlCLuCWKPbtykf
         OP0fxUmRqTeefkj8roSMhQQDkDpDliCskmJwk=
MIME-Version: 1.0
Date: Mon, 9 Nov 2009 18:08:40 +0100
Message-ID: <3642a3130911090908i55d6e1f2y6d9a5106d9febfc6@mail.gmail.com>
Subject: Kernel 2.6.29+ broke Cisco VPN Client
From: Mariusz Smykula <mariuszs@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.31 go mainstream and there new problem grow up for many
users of poor Cisco VPN Client with certs authentication (there is no
alternative for this). I know, this is not yours problem but maybe
someone can help us and look into cisco vpn client code. There is
problem with freezing system after some time from connection. This
problem start with 2.6.29 kernel.

More info about this:
http://forum.tuxx-home.at/viewforum.php?f=15&sid=8a427ce7fd1fd5b5c5110348e8f0041a
http://www.painfullscratch.nl/code/vpn/
http://ilapstech.blogspot.com/2009/09/cisco-vpn-client-on-karmic-koala.html#comment-form
http://projects.tuxx-home.at/ciscovpn/

Sorry for disturbing.

-- 
Mariusz Smyku³a
mariuszs-gmail-com
