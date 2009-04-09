Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbZDIIpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbZDIIpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 04:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZDIIol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 04:44:41 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:23453 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbZDIIoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 04:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=F7j11o6gjVprwHfn7/VqByngT3MzKEguW64sorQqTqKJpZIVNIKhSxlov9mQIs+L0z
         ZVf/2VvJh95epZ7BMz1dbgZW9H8zBg0tiLDs90KKDs8vUt7QcbtvpobrMuenJKBWxEAW
         lVUMqp99jIy+jB1exLgNXf7blcLmgWbtjKjPM=
MIME-Version: 1.0
Date: Thu, 9 Apr 2009 16:44:38 +0800
Message-ID: <b7997bdf0904090144g66548dftefe8c933116a8b2d@mail.gmail.com>
Subject: b44: constantly "powering down PHY" during high network
From: xinglp <xinglp@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

b44: constantly "powering down PHY" during high network
I can reproduce it when I initiate 10K connection to remote server.
