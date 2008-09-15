Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYIOA0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYIOA0E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 20:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYIOAZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 20:25:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51046 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYIOAZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 20:25:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: XFS does not recognise mount options in 2.6.27-rc6
Date: Mon, 15 Sep 2008 02:31:00 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-xfs@oss.sgi.com
References: <pan.2008.09.14.18.53.20@telenet.be>
In-Reply-To: <pan.2008.09.14.18.53.20@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809150231.01220.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 14 of September 2008, Frederik Himpe wrote:
> In 2.6.27-rc6, XFS still does not recognise mount options like logbufs and 
> others. Because of this, at boot time it fails to mount the partitions rw, 
> making the system unusable.

Was 2.6.26 OK?

Rafael
