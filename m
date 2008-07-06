Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbYGFOyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbYGFOyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbYGFOyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:54:02 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:43878 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbYGFOyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xv13hytG8uwnD4JIJinLYPlmD93Zw09IyQr+wmuJ7g826AlAjLeeal4+gXTWfBIdS9
         iGHT3Xo0XgGmyGJsJHrSBd+QCGT1nQbH/l+hVWlHtKbGW0aubJ/YjzkEygmDjBx1W0IZ
         OxarqHoajsh+B92953XEka8CYHBhtqZ6FnhDY=
Message-ID: <237967ef0807060754t4bf0ab8el7362e69aac4699b5@mail.gmail.com>
Date: Sun, 6 Jul 2008 16:54:00 +0200
From: "Mikael Magnusson" <mikachu@gmail.com>
To: "Jan Engelhardt" <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] GIT 1.5.6.2
Cc: "Junio C Hamano" <gitster@pobox.com>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0807061444250.28765@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7vy74fo9t4.fsf@gitster.siamese.dyndns.org>
	 <alpine.LNX.1.10.0807061444250.28765@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/6 Jan Engelhardt <jengelh@medozas.de>:
>
> On Sunday 2008-07-06 07:34, Junio C Hamano wrote:
>>Junio C Hamano (9):
>>      Allow "git-reset path" when unambiguous
>>      diff --check: do not discard error status upon seeing a good line
>>      git-shell: accept "git foo" form
>>      GIT 1.5.4.6
>>      GIT 1.5.5.5
>>      Start draft release notes for 1.5.6.2
>>      Work around gcc warnings from curl headers
>>      Fix executable bits in t/ scripts
>>      GIT 1.5.6.2
>
> Three git versions?

I believe this is related to moving to the dash-less form of receive-pack et al.

-- 
Mikael Magnusson
