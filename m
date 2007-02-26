Return-Path: <linux-kernel-owner+w=401wt.eu-S1751275AbXBZLw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbXBZLw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 06:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbXBZLw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 06:52:27 -0500
Received: from web26903.mail.ukl.yahoo.com ([217.146.176.92]:20439 "HELO
	web26903.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751275AbXBZLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 06:52:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=RY4q+9rVEnt6QzbmlJDjrv0OXcjSAdLAFESCEWLBv03tmMTg5bZc894lECBIoYeAcxuqdMha5/iKH+gxMw9FC49F921DX+JYWi4KA6XTxZrq/2x3lExqCoj3yXQH0Y2Kifw2h5fHcWt9mXnJjqlHLWvtGYM/Ct4uWRc5LroAUx8=;
X-YMail-OSG: 3w6AbNgVM1lcASRcHiH1RQq1_ZsPxjK9WBByh1gtxJLTfd.ezwzkKRtmiZ1MPkIWClG_r911MG7uMAOGWbPYivH7M_zEXfTlzn674KdLcz.UQo6x_Ls041YhHlcrUVM1RJ5aaxeqiIR7
Date: Mon, 26 Feb 2007 12:52:21 +0100 (CET)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <828425.46562.qm@web26903.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> a. Can someone please confirm the described problem?

  I can confirm that "mdir a:" without a floppy in the driver does not crash.
  If there is a floppy, it crashes immediately (do "sync; sync" before to
 limit file corruption). Tried with and without tickless, not related (no change).
 If lock related, this system is UP Athlon XP 1.4 GHz.

 Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
