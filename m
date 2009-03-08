Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZCHRju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZCHRju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 13:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZCHRjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 13:39:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:61681 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZCHRjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 13:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=ni9O9HeolVL3VS/yH1vkFD3pj6iJ5m5KohfNJUzdg5aBYM9W1jvcS/LhpsFd4vuuJO
         2WypqIU+/yDXLLip1OTcaN5X3CG4OBxpMAtWPdgmDYRBiXtXyjewTXCYHc38rTkR9ArT
         OGsYC2AtYKr+FWLm0zk7cY21Z6QcLw04Qjx5Q=
MIME-Version: 1.0
Date: Sun, 8 Mar 2009 13:39:40 -0400
X-Google-Sender-Auth: 2c2e50b399daabec
Message-ID: <177c2b150903081039v5abc3441r61020cc10844b1a0@mail.gmail.com>
Subject: doubt about path_walk() function
From: Mhayk Whandson <eu@mhayk.com.br>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am trying to compile the project McAfee LinuxShield with kernel
2.6.27-9 and I have a problem with function path_walk():
linuxshield/scan.c|998| error: implicit declaration of function ‘path_walk’

Searching in the internet, I can see that this function was removed in
one some kernel version, so how can I fix this problem ?

best regards,

-- 
Mhayk Whandson
Linux User #413723
E-mail: eu@mhayk.com.br
