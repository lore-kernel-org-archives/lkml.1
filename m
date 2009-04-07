Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZDGIh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZDGIh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZDGIhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:37:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:4997 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZDGIhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:37:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=AcAwiQw9odE8f/ir7WuQAlvQHqi3MLioPObzNBTBZB/iEg4+2CMG00YbE6BSWpELE0
         COLSDapEIbxIQDupOnmu3FR3vftpcbvVqQylgCikEgYw0OlqVIjJ9PqYu1BSnB2nsqpd
         rjP1gxz7c9ikcMv63uzId9Lhzl074EIvtGMrE=
MIME-Version: 1.0
From: Baybal Ni <nikulinpi@gmail.com>
Date: Tue, 7 Apr 2009 18:36:55 +1000
Message-ID: <ff479ab60904070136r5cdf7dd1mf149c9671374ff1e@mail.gmail.com>
Subject: Feature request: per interface congestion algorythm selection
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TCP performance over various physical connections depends on the use
of right congestion algorythm dramaticaly. But linux provides only one
global switch for congestion algorythm selection for all connections.
