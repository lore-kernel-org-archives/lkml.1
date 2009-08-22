Return-Path: <linux-kernel-owner+w=401wt.eu-S933281AbZHVVvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbZHVVvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 17:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932905AbZHVVvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 17:51:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46294 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376AbZHVVvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 17:51:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue correctly
Date: Sat, 22 Aug 2009 23:52:07 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Andy Whitcroft <apw@canonical.com>, "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1250872904-10993-1-git-send-email-apw@canonical.com> <20090822112103.49174d6b@neptune.home>
In-Reply-To: <20090822112103.49174d6b@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908222352.07482.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 August 2009, Bruno Prémont wrote:
> Rafael, this matches regression bug #13942 "Troubles with AoE and
> uninitialized object".
> 
> Will test and report how it works out here.

Great, thanks for the information.

Rafael
