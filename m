Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbZDXKmj (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 24 Apr 2009 06:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZDXKma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:42:30 -0400
Received: from f139.mail.ru ([194.67.57.120]:57041 "EHLO f139.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZDXKm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:42:29 -0400
From: Rutkov Denis <dendron2000@mail.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: =?koi8-r?Q?Re[3]=3A_High_kernel_CPU_usage_when_copying_files?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: 194.226.199.147 via proxy [194.226.199.226]
Date: Fri, 24 Apr 2009 14:42:25 +0400
References: <S1754762AbZDXKcG20090424103206Z+228@vger.kernel.org>
In-Reply-To: <S1754762AbZDXKcG20090424103206Z+228@vger.kernel.org>
Reply-To: Rutkov Denis <dendron2000@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1LxIrR-000JB0-00.dendron2000-mail-ru@f139.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, definitely high CPU usage. In "top" I get high "sy" percentage. Processes waiting for I/O cannot cause this, right?
