Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYJ0Vlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYJ0Vlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYJ0Vlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:41:45 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3730 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYJ0Vlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:41:44 -0400
Date: Mon, 27 Oct 2008 22:41:38 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.26] OOPS in free_thread_xstate
Message-ID: <20081027214138.GU8318@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Sat Oct 25 11:44:16 CEST 2008
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,                                                                                                                                                   
                                                                                                                                                      
While running my http://vanheusden.com/pyk/ script (which randomly
inserts and removes modules) I triggered the folllowing oops in a 2.6.26
kernel on an IBM laptop, pentium 2. Unfortunately I could not pipe it to
a file or so but a picture of the oops can be found here:
http://keetweej.vanheusden.com/gallery/misc/dcp_3277?full=1


Folkert van Heusden

-- 
MultiTail na wan makriki wrokosani fu tan luku den logfile nanga san
den commando spiti puru. Piki puru spesrutu sani, wroko nanga difrenti
kroru, tya kon makandra, nanga wan lo moro.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
