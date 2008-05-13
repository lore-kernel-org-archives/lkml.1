Return-Path: <linux-kernel-owner+w=401wt.eu-S1760421AbYEMRA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421AbYEMRA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYEMRAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:00:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:47884 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYEMRAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=QXCDpMZfYZGVnYjxwgO++4miTG8ik7x1U/8mbXqjdXOOx46LIuaTK5eOk2a3pE0zhibzz0vMvjctiz13TsFjblUOLex3gOqJWNqyJ4tJAUgo9njpfxSAtLGQ0iEKCjNA2A2uTD7v5pStYBH29ksrWjal06/jHGzPG2UZGkpuzQU=
User-Agent: quilt/0.46-1
Date: Tue, 13 May 2008 20:55:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, jirislaby@gmail.com
Subject: [patch 0/2] x86 - head_64.S cleanup
Message-ID: <4829c921.0c07560a.6b08.0788@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains the small cleanups on head_64.S file.
Though the diff is really small it touches quite critical
part of booting procedure so please review them *in very
sceptical manner*. At least the kernel was successfully
booted by KVM.

		- Cyrill -

-- 
