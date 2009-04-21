Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbZDUPVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbZDUPVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZDUPVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:21:41 -0400
Received: from langos.euedge.com ([209.190.22.130]:34171 "EHLO
	langos.euedge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZDUPVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:21:40 -0400
Message-ID: <49EDE481.1020304@maroy.hu>
Date: Tue, 21 Apr 2009 17:21:37 +0200
From: =?UTF-8?B?TWFyw7N5IMOBa29z?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
References: <49EDC44D.90106@maroy.hu> <200904211526.34199.oliver@neukum.org> <49EDCB0F.3040802@maroy.hu> <200904211539.23671.oliver@neukum.org>
In-Reply-To: <200904211539.23671.oliver@neukum.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

>> ok, let me upgrade to 2.6.28 first, and if the proplem still persists,
>> I'll compile 2.6.29 with the above settings manually.

FYI, I upgraded to 2.6.28 (ubuntu 9.04), and the problem still persists.
will go ahead and compile 2.6.29.


Akos

