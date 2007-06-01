Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbXFAInR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbXFAInR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 04:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbXFAInH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 04:43:07 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37656 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbXFAInG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 04:43:06 -0400
Date: Fri, 1 Jun 2007 10:42:54 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: gshan <gshan@alcatel-lucent.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: How to access kdb explicitly
In-Reply-To: <465FC9FD.7060202@alcatel-lucent.com>
Message-ID: <Pine.LNX.4.64.0706011042320.29896@twin.jikos.cz>
References: <42c83d030706010019u13219322o7cec0c7aa08dd01f@mail.gmail.com>
 <465FC9FD.7060202@alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, gshan wrote:

> I want to access kdb explicitly. For example, I could recognize the 
> special characters inside console driver. If the the special characters 
> are detected , then drop to kdb immediately. However, I don't know what 
> should I to do after the special characters received.

See http://www.ibm.com/developerworks/linux/library/l-kdbug/ - section 
"Activating KDB".

-- 
Jiri Kosina
