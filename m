Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbZANUm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbZANUm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZANUmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:42:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:54844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbZANUmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:42:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=r/+M+8Zu+yXmg6oCrRwtGoQ2tSqXpYfuc7O2UofebjdqvO9Uhed70NW+h0jIMK5IOb
         zTxVyuVIX3oYCO4TVqdYNxpBfR5lGMRs3ouEvpE0CEzuQk6MB+ahZmC9JPLK7AY7wsVZ
         vjO7b4GESbw+kn7ccgvs3cw2abV8sysi91u/E=
User-Agent: quilt/0.46-1
Date: Wed, 14 Jan 2009 23:37:45 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: harvey.harrison@gmail.com, sam@ravnborg.org, jaswinderrajput@gmail.com
Subject: [patch 0/5] x86 -tip: headers cleanup
Message-ID: <496e4e23.0305560a.4545.ffffaf3c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small series of headers cleanup, easy to bisect.
make headers_check still complains about vars
being found in comments but this is just a false
alarm. Please review.

		Cyrill
-- 
