Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbXIJBJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbXIJBJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 21:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbXIJBJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 21:09:18 -0400
Received: from mail99.megamailservers.com ([216.251.36.99]:56214 "EHLO
	mail99.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbXIJBJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 21:09:17 -0400
X-Authenticated-User: jgeorgas.georgas.ca
Subject: unfamiliar notation
From: "James C. Georgas" <jgeorgas@georgas.ca>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Georgas Software Solutions
Date: Sun, 09 Sep 2007 21:09:01 -0400
Message-Id: <1189386541.7365.50.camel@Tachyon.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just came across a notation that I haven't seen before. It's in
scripts/mconf.c:

	str_append(&help, _(menu_get_help(menu)));

What's the deal with the underscore and the parentheses surrounding the
call to menu_get_help?

James
	/\V

