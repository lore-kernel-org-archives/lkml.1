Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYCTDDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYCTDDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 23:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYCTDC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 23:02:56 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:64378 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYCTDCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 23:02:55 -0400
Message-ID: <5d6222a80803180930v732405cao8b5465f3842df9b1@mail.gmail.com>
Date: Tue, 18 Mar 2008 13:30:45 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: compilation break
Cc: "Ingo Molnar" <mingo@elte.hu>, yinghai.lu@sun.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 513f484dfe5cbb53e73ef1729703e7030e799487 breaks compilation
with X86_VISW.

I don't have enough knowledge of the subtles of those things, so I'm
just reporting it.
But my educated guess is that it shouldn't be static, and the answer
to the question that goes in the end of the commit log is "yes" ;-)

-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
