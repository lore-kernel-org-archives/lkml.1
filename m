Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXJBP0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXJBP0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXJBPZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:25:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:64358 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbXJBPZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kOZTdqmdOh5R8slWEqYzEodmieo2oLKpxAc7Kwcy7nnqx60UfeTOG7TWinyEn/n9TDdIrymodon7lImG1Vi8n3V8B0nra28Fc5ZHbllpEm/FDJmjQrg+M4/uQwvva7/FPqY7BUQ9o6raeozCQN+DnT7c158K58qjSfKPZfbkw6I=
Message-ID: <f36b08ee0710020825x559a1046n6b7a2070d5591320@mail.gmail.com>
Date: Tue, 2 Oct 2007 17:25:52 +0200
From: "Yakov Lerner" <iler.ml@gmail.com>
To: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: get amount of "entropy" in /dev/random ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From the userlevel, can I get an estimate of  "amount of entropy"
in /dev/random, that is, the estimate of number of bytes
readable until it blocks ? Of course multiple processes
can read bytes and this would not be exact ... but still .. as an upper
boundary estimate ?

Thanks
Yakov
