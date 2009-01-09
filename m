Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZAIUAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZAIUAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbZAIUAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:00:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:20600 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbZAIUAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:00:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=TtEMPxq/KKH0y/36wxP6iJtaJdFNlNalh3yUMHWncZna47s1YoRLODnwd8anCmGDFp
         yRKSvZTtVzEI498Jv4sybshwD9Q6wqbz/05M1Kg7fysLgizRexBBXEECcIc+XDWhMTSv
         +DghMf7AV1COEv920NxW+w8qkYWm9PZwDbE7Q=
User-Agent: quilt/0.46-1
Date: Fri, 09 Jan 2009 22:51:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: gorcunov@gmail.com, devel@openvz.org, xemul@openvz.org
Subject: [RFC 0/4] net namespace for PPP
Message-ID: <4967acca.0437560a.511e.0221@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a series of RFC in attempt to implement
net-namespaces for PPP protocol (including PPPoE
and PPPoL2TP).

I would really appreciate _any_ kind of comments.
Really doubt if there is no bugs in my implementation
but it's RFC after all. Mostly -compile- tested so it
requires strong review. One more time -- I would admire
any kind of comments (even like -- it's completely broken
and full of sh*t would be fine -- but with details please :).

		Cyrill
-- 
