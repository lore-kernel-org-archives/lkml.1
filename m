Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZCZKJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZCZKJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 06:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZCZKJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 06:09:42 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:40950 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbZCZKJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 06:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Rp8Gvyd0vl8pVyh/988nUosMEM1FNU8nKlgN6G7OumTCKL0Z4d+XV3DvW7jvb4bKXG
         kDYwGAsZ6SnU5dOzzbKcNWz8waa17AVD0BzVcXlkmmd8tL6SjGnQKT9f3FEuZdSip8Kk
         91fB59n8jtddgV7n15ZACkvulKqoXv3bf+s5I=
MIME-Version: 1.0
In-Reply-To: <ab4346860903260308t76edb9b7n165c58b0cb654948@mail.gmail.com>
References: <ab4346860903260308t76edb9b7n165c58b0cb654948@mail.gmail.com>
Date: Thu, 26 Mar 2009 12:09:38 +0200
Message-ID: <ab4346860903260309y4c7ce885t69e074718354de84@mail.gmail.com>
Subject: how to extract 'uname -r' string from bzImage without booting it ?
From: Victoria Muntean <vikimun@gmail.com>
To: Kernel Linux <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How can make (or find) a script or utility
that can extract  'uname -r' string from bzImage without booting it ?

Thanks
Viki
