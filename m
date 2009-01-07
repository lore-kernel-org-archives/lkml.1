Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbZAGQUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbZAGQUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZAGQUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:20:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:62697 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZAGQUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:20:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=w/mqKtLxqyZHXu3j8uEGp0/n7nGZlSTJgO4VvIOhlah4UTFz4hyhVRHak1jQxyjWol
         09CrXr9mjk505xhFp6hcUUoJ/GSNYVunERO9M1z+PWEsBhsYxVObmCJogFsf8JZyIbZ0
         mgYWyp3DJ3gBcFiKZ5HCAElt7NjEqGIJkTAGY=
From: Bryan Wu <cooloney@kernel.org>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Bugs fixing for USB composite gadget driver
Date: Thu,  8 Jan 2009 00:21:17 +0800
Message-Id: <1231345279-26618-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Greg,

I found 2 issues when I was developing USB Audio gadget driver.
Please take a look.

Thanks
-Bryan
