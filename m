Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZDXQXq (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 24 Apr 2009 12:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZDXQXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:23:36 -0400
Received: from f160.mail.ru ([194.67.57.33]:62856 "EHLO f160.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZDXQXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:23:36 -0400
From: Rutkov Denis <dendron2000@mail.ru>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org
Subject: =?koi8-r?Q?Re[4]=3A_High_kernel_CPU_usage_when_copying_files?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [93.92.201.44]
Date: Fri, 24 Apr 2009 20:23:20 +0400
References: <878wlqqghw.wlhtd@fancy-poultry.org>
In-Reply-To: <878wlqqghw.wlhtd@fancy-poultry.org>
Reply-To: Rutkov Denis <dendron2000@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1LxOBM-000LZa-00.dendron2000-mail-ru@f160.mail.ru>
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In idle state have 0 of these "D-state" processes. During file copying I have 1-2 of them.

Using sar I've collected the following statistics: during file copying system load raises to 30% (from 5%), user load raises to 15% (from about 7%) and io wait raises to 60% (from 0-1%). Idle part drops to 0% (from about 87%).

